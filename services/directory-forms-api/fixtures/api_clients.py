from client.models import Client

if Client.objects.count() == 0:
    Client.objects.create(
        identifier='8bf25382-1605-4cec-bd7c-db2b7052604b',
        access_key=
        'oM8tpF4W0bzDf9hVVkTfwYcuDriIHeJHUqYOU0OasUjwiczv4THTVbyJT8ipkFC5',
        name='great-domestic-ui')
