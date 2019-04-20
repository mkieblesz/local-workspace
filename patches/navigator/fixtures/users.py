from django.contrib.auth import get_user_model

User = get_user_model()

if User.objects.filter(username='admin').count() == 0:
    user_data = {
        'username': 'admin',
        'email': 'admin@example.com',
        'password': 'admin',
        'first_name': 'Mr',
        'last_name': 'Admin'
    }
    User.objects.create_superuser(**user_data)
