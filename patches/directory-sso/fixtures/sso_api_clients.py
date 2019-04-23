from oauth2_provider.models import get_application_model

# create oauth application for export-opportunities
Application = get_application_model()
if Application.objects.count() == 0:
    Application.objects.create(
        name='export-opportunities',
        redirect_uris='http://opportunities.trade.great:8002/export-opportunities/users/auth/exporting_is_great/callback',
        skip_authorization=True,
        client_type=Application.CLIENT_CONFIDENTIAL,
        authorization_grant_type=Application.GRANT_AUTHORIZATION_CODE,
        client_id='efcy4CUD2bhChR3We8K1LunKLSmwVe8uW4qa2Ipv',
        client_secret='VbNAcpsal6bvqLoALsebAsC6gVj8XtoxiO58ukI7M8AyOcp7gowal0f0y6aN0KQrmDFfvBuhXZFwSAwmt4SHMnBXy1tDs0uttK8CQAiWGY1DRHPjXoCSyP6GLZUiLTeg',
    )
