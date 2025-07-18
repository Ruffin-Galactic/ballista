import grpc
import pyballista.proto.ballista_pb2_grpc as ballista_pb2_grpc
import pyballista.proto.ballista_pb2 as ballista_pb2

class BallistaClient:
    def __init__(self, host="localhost", port=50050):
        self.channel = grpc.insecure_channel(f"{host}:{port}")
        self.client = ballista_pb2_grpc.BallistaSchedulerStub(self.channel)

    def execute_query(self, sql):
        request = ballista_pb2.ExecuteQueryParams(
            query=sql,
            settings={"batch_size": "1024"}
        )
        response = self.client.ExecuteQuery(request)
        return response.job_id

    def fetch_stages(self, job_id):
        request = ballista_pb2.FetchQueryStagesParams(job_id=job_id)
        return self.client.FetchQueryStages(request)
