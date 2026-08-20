# Shuddha Sangeetham — Instagram Automation Pipeline
## Claude Code Handoff Spec

## Goal
Queue an Instagram post (photo + audio → rendered video + caption) from a
Google Sheet, and have it auto-publish to @shuddha.sangeetham at a scheduled
date/time — no manual intervention once queued.

## Architecture
Matches the existing ATL pattern: FastAPI + APScheduler + Docker on Anjaneya,
same as Daily Cause List.

```
Google Sheet (manifest) --poll--> APScheduler job
                                        |
                                        v
                          Fetch photo + mp3 from Drive
                                        |
                                        v
                          ffmpeg: combine into mp4
                                        |
                                        v
                      Host mp4 publicly (Cloudflare Tunnel)
                                        |
                                        v
              Graph API: create container -> poll -> publish
                                        |
                                        v
                       Update Sheet status column
```

A **separate** APScheduler job handles Instagram token refresh independently
(runs monthly, unrelated to the posting schedule).

## Credentials needed (provide at session start, do not commit to Git)
- Instagram App ID, App Secret
- Instagram long-lived access token (60-day) + Instagram User ID
- Google service account JSON key (Drive + Sheets API access)
- IDs/URLs of the Drive folder and manifest Sheet

## Google Sheet manifest schema
| column | notes |
|---|---|
| photo | filename in the Drive folder |
| audio | filename in the Drive folder (mp3) |
| caption | post description text |
| scheduled_at | ISO datetime, IST |
| status | queued / rendering / posted / failed |

## Pipeline steps

1. **Poll manifest** — APScheduler job runs on an interval (e.g. every
   10–15 min), reads the Sheet via the Google Sheets API, finds rows where
   `status == queued` and `scheduled_at <= now`.

2. **Fetch source files** — download the matching photo + mp3 from the
   Drive folder via the Drive API using the service account credentials.

3. **Render video (ffmpeg)** — combine the still photo with the mp3 into an
   mp4: 1:1 or 9:16 aspect ratio (confirm preference), image held for the
   full duration of the audio track. Output to a working directory.

4. **Host the video** — drop the rendered mp4 in a directory served via the
   existing Cloudflare Tunnel so it's reachable by a public HTTPS URL (Graph
   API pulls from a URL, doesn't accept direct upload).

5. **Publish via Graph API (two-step)**
   - `POST /{ig-user-id}/media` with `video_url` + `caption` → creates a
     container, returns a container ID.
   - Poll `GET /{container-id}?fields=status_code` until `FINISHED`
     (handle `ERROR` status with retry/failure logging).
   - `POST /{ig-user-id}/media_publish` with the container ID → goes live.

6. **Update the Sheet** — write back `status = posted` (or `failed` with an
   error note) so the queue reflects reality.

7. **Token refresh job (separate, monthly)** — call
   `GET https://graph.instagram.com/refresh_access_token` with the current
   token before it's 60 days old (run this job every ~45 days), store the
   refreshed token wherever the publish job reads it from.

## Notes / constraints
- Rate limit: ~25 published posts/24hrs — not a concern at this volume.
- No text-only posts — every post needs the rendered video.
- Keep this session scoped to the pipeline itself — no admin dashboard, no
  multi-post batch UI. Add those later if the queue-via-Sheet workflow
  proves it's needed.
- Error handling: if ffmpeg render or the Graph API publish fails, mark the
  row `failed` with a reason rather than silently retrying forever.

## Out of scope for this session
- Admin dashboard / web UI
- Multi-account support
- Analytics on post performance
