{
  "aws": {
    "athena": [
      {
        "bucket": "${bucket}",
        "region": "${region}",
        "database": "${database}",
        "table": "${table}",
        "workgroup": "${workgroup}",
        "account": "${account}",
        "authorizer": {
          "authorizerType": "${authorizer_type}",
          "id": "${access_key_id}",
          "secret": "${secret_access_key}"
        }
      }
    ]
  }
}