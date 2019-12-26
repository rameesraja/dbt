select '{{ var("my_model_variable") }}' as model_variable,
'{{ var("my_package_variable") }}' as package_variable,
'{{ var("my_global_variable") }}' as global_variable,
'{{ var("my_runtime_variable","No Value") }}' as runtime_variable
