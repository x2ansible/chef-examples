default['fastapi_tutorial']['app_path'] = '/opt/fastapi-tutorial'
default['fastapi_tutorial']['repository'] = 'https://github.com/dibanez/fastapi_tutorial.git'
default['fastapi_tutorial']['revision'] = 'main'
default['fastapi_tutorial']['service_port'] = 8000
default['fastapi_tutorial']['project_name'] = 'FastAPI Tutorial'
default['fastapi_tutorial']['api_version'] = 'v1'
default['fastapi_tutorial']['database_url'] =
  'postgresql://fastapi:fastapi_password@localhost/fastapi_db'
default['fastapi_tutorial']['service'] = {
  'workers' => 2,
  'timeout' => 30,
}
