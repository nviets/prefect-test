from dask_jobqueue import SLURMCluster
import pandas
 
import os
 
# Define the Dask cluster as a collection of Slurm jobs
# Note that Dask clusters do not autoscale, so you need to specify the cores, processes, memory, etc.
cluster = SLURMCluster(
    cores=1,
    processes=4,
    memory="0.5GB",
    queue="stage199",
    walltime="00:1:00",
    local_directory='/opt/revr/tmp',
    death_timeout="1m",
    log_directory=f'/u/{os.environ["USER"]}/repos/dask_jobqueue_logs/',
    project="PrefectDask")
 
# If you or somebody else launch more than one Dask cluster on the same server you may see a warning about ip ports. It is harmless.
 
# Activate the client
from dask.distributed import Client
client = Client(cluster)
 
cluster.scale(4)
 
import dask.dataframe
import time

# run a simple prefect pipeline
def my_task(start: str) -> str:
    time.sleep(5)
    return start

def dask_pipeline():
    res = my_task("1")
    return res

rpt = dask_pipeline()

print(rpt)

# The cluster must be stopped when it is no longer needed
cluster.close()
