c = get_config()

c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False
c.NotebookApp.allow_root = True
c.NotebookApp.token = ''
c.NotebookApp.default_url = '/lab'

# SQL Magic configuration
c.SqlMagic.autopandas = True
c.SqlMagic.feedback = True
c.SqlMagic.displaycon = True

# Configure MLflow
os.environ['MLFLOW_TRACKING_URI'] = 'http://mlops:5000'
os.environ['MLFLOW_S3_ENDPOINT_URL'] = 'http://object-storage:9000'
os.environ['AWS_ACCESS_KEY_ID'] = 'admin*12345'
os.environ['AWS_SECRET_ACCESS_KEY'] = 'psswrd*12345'
