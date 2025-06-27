# PyBallista

A modern Python gRPC client for [Apache Ballista](https://github.com/apache/datafusion-ballista), a distributed SQL query engine built on Apache Arrow and DataFusion.

## Why This Project Exists

The official Ballista project provides powerful distributed execution capabilities, but lacks an up-to-date and maintained Python client. This project fills that gap by:

- Dynamically pulling the latest protobuf definitions from the upstream Ballista repo
- Building gRPC bindings during CI
- Publishing a clean and simple Python client

It allows you to easily connect to a Ballista scheduler and run SQL queries from any Python environment.

---

## Installation

Once a release is published, you can install it directly from GitHub:

```bash
pip install https://github.com/Ruffin-Galactic/ballista/releases/download/v0.1.0/pyballista-0.1.0-py3-none-any.whl
```

Replace the version with the latest tag if needed.

---

## Example Usage

```python
from pyballista.client import BallistaClient

# Connect to a running scheduler (e.g., started via Docker)
client = BallistaClient(host="localhost", port=50050)

# Submit a simple SQL query
job_id = client.execute_query("SELECT 1")
print("Submitted job:", job_id)

# Fetch execution stages
stages = client.fetch_stages(job_id)
print("Query stages:", stages)
```

---

## Development and Build

This project uses `hatch` for packaging and builds the protobuf stubs on GitHub Actions. All `.proto` files are fetched live from the Apache Ballista repo on each release build.

To build locally:

```bash
pip install grpcio-tools hatch
# clone and copy proto files manually if needed, or rely on GitHub Actions
hatch build
```

---

## License

Apache 2.0 - same as the upstream Ballista project.
