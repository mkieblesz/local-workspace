from django.contrib.auth import get_user_model
from sso.user.models import UserProfile

User = get_user_model()

if User.objects.filter(email='admin@example.com').count() == 0:
    user_data = {
        'email': 'admin@example.com',
        'password': 'admin',
    }
    user = User.objects.create_superuser(**user_data)
    UserProfile.objects.create(user=user, first_name='Mr', last_name='Admin', job_title='Admin')
