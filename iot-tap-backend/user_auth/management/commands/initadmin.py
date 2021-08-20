from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.conf import settings
import backend.models as m

class Command(BaseCommand):
    def handle(self, *args, **options):
        User = get_user_model()
        admin_name = self.__get_secrets("admin_name")
        if not User.objects.filter(username=admin_name).exists():
            admin_email = self.__get_secrets("admin_email")
            admin_password = self.__get_secrets("admin_password")
            admin = User.objects.create_superuser(admin_name, admin_email, admin_password)
            self.stdout.write(self.style.SUCCESS('Successfully create superuser "%s"' % admin_name))
    
    def __get_secrets(self, secret_name):
        try:
            with open('/run/secrets/{}'.format(secret_name), 'r') as secret_file:
                return secret_file.read().strip(' \n')
        except IOError:
            return None
