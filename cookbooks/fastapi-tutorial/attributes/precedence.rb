override['fastapi_tutorial']['project_name'] = 'FastAPI Tutorial Production'
force_default['fastapi_tutorial']['service_port'] = 8001
force_override['fastapi_tutorial']['database_url'] =
  'postgresql://fastapi:fastapi_password@localhost/fastapi_production'
force_default!['fastapi_tutorial']['service'] = {
  'workers' => 4,
}
