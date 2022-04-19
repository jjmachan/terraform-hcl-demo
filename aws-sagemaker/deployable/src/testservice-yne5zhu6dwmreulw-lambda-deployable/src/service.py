import bentoml
from bentoml.io import JSON, NumpyNdarray, PandasDataFrame, File, Multipart, Text

SERVICE_NAME = "testservice"
svc = bentoml.Service(SERVICE_NAME)


@svc.api(input=JSON(), output=JSON())
async def json(input_json):
    print(input_json)
    return {
        "input_received": input_json,
        "bentoml_version": bentoml.__version__,
    }


@svc.api(input=NumpyNdarray(), output=NumpyNdarray())
async def ndarray(input_ndarray):
    print(input_ndarray)
    return input_ndarray


@svc.api(input=PandasDataFrame(), output=PandasDataFrame())
async def pandas(input_pandas):
    print(input_pandas)
    return input_pandas


@svc.api(input=File(), output=File())
async def file(input_file):
    print(input_file)
    return input_file


@svc.api(input=Multipart(text=Text()), output=Text())
async def multipart(text):
    print(text)
    return "ok"
