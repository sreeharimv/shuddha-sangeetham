import glob
import json
import os
import subprocess
import sys
import time

RAW_DIR = "/home/sreeh007/shuddha-sangeetham/scraper/data/raw"
BATCH_SIZE = 1000

def main():
    files = sorted(
        glob.glob(os.path.join(RAW_DIR, "*.json")),
        key=lambda p: int(os.path.splitext(os.path.basename(p))[0]) if os.path.splitext(os.path.basename(p))[0].isdigit() else 999999
    )
    print(f"Found {len(files)} raw JSON files.")
    
    total_records = 0
    total_updated = 0
    total_inserted = 0
    all_new_names = set()

    batch = []
    batch_num = 0
    num_batches = (len(files) + BATCH_SIZE - 1) // BATCH_SIZE

    t0 = time.time()
    for f in files:
        try:
            with open(f, "r", encoding="utf-8") as fp:
                data = json.load(fp)
                if (data.get("name") or "").strip():
                    batch.append(data)
        except Exception as e:
            print(f"Error reading {f}: {e}")

        if len(batch) >= BATCH_SIZE:
            batch_num += 1
            up, ins, names = run_batch(batch, batch_num, num_batches)
            total_records += len(batch)
            total_updated += up
            total_inserted += ins
            all_new_names.update(names)
            batch = []

    if batch:
        batch_num += 1
        up, ins, names = run_batch(batch, batch_num, num_batches)
        total_records += len(batch)
        total_updated += up
        total_inserted += ins
        all_new_names.update(names)

    elapsed = time.time() - t0
    print("\n" + "=" * 50)
    print(f"Import complete in {elapsed:.1f}s.")
    print(f"Total processed: {total_records}")
    print(f"Total updated:   {total_updated}")
    print(f"Total inserted:  {total_inserted}")
    print(f"New references:  {len(all_new_names)}")
    print("=" * 50)

def run_batch(records, batch_num, total_batches):
    code = "import sys, json; from services import krithis; res = krithis.bulk_import(json.load(sys.stdin), \"admin\"); print(json.dumps(res))"
    proc = subprocess.Popen(
        ["docker", "exec", "-i", "ss-studio", "python3", "-c", code],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    out, err = proc.communicate(input=json.dumps(records))
    if proc.returncode != 0:
        print(f"[Batch {batch_num}/{total_batches}] ERROR (exit code {proc.returncode}): {err}")
        sys.exit(1)
    res = json.loads(out.strip())
    print(f"[Batch {batch_num:02d}/{total_batches:02d}] Records: {res['total']} | Updated: {res['updated']} | Inserted: {res['inserted']} | New refs: {len(res['new_names'])}")
    return res["updated"], res["inserted"], res["new_names"]

if __name__ == "__main__":
    main()
