import bentoml

from service import SERVICE_NAME

bentoml.bentos.build_bentofile('./bentofile.yaml')
bentoml.export_bento(SERVICE_NAME, 'saved_dir')
