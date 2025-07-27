# import os

# BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# SECRET_KEY = os.getenv("SECRET_KEY")
# DEBUG = os.getenv("DEBUG") is not None
# ALLOWED_HOSTS = ["*"]

# INSTALLED_APPS = [
#     "django.contrib.admin",
#     "django.contrib.auth",
#     "django.contrib.contenttypes",
#     "django.contrib.sessions",
#     "django.contrib.messages",
#     "rest_framework",
#     "api",
# ]

# MIDDLEWARE = [
#     "django.middleware.security.SecurityMiddleware",
#     "django.contrib.sessions.middleware.SessionMiddleware",
#     "django.middleware.common.CommonMiddleware",
#     "django.middleware.csrf.CsrfViewMiddleware",
#     "django.contrib.auth.middleware.AuthenticationMiddleware",
#     "django.contrib.messages.middleware.MessageMiddleware",
#     "django.middleware.clickjacking.XFrameOptionsMiddleware",
# ]

# ROOT_URLCONF = "app.urls"

# TEMPLATES = [
#     {
#         "BACKEND": "django.template.backends.django.DjangoTemplates",
#         "DIRS": [],
#         "APP_DIRS": True,
#         "OPTIONS": {
#             "context_processors": [
#                 "django.template.context_processors.debug",
#                 "django.template.context_processors.request",
#                 "django.contrib.auth.context_processors.auth",
#                 "django.contrib.messages.context_processors.messages",
#             ],
#         },
#     },
# ]

# WSGI_APPLICATION = "app.wsgi.application"

# DATABASES = {
#     "default": {
#         "ENGINE": "django.db.backends.postgresql",
#         "NAME": os.getenv("DATABASE_NAME"),
#         "USER": os.getenv("DATABASE_USER"),
#         "PASSWORD": os.getenv("DATABASE_PASSWORD"),
#         "HOST": os.getenv("DATABASE_HOST", "localhost"),
#         "PORT": os.getenv("DATABASE_PORT", "5432"),
#     }
# }

# AUTH_PASSWORD_VALIDATORS = [
#     {
#         "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
#     },
#     {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator", },
#     {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator", },
#     {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator", },
# ]

# LANGUAGE_CODE = "en-us"

# TIME_ZONE = "UTC"

# USE_I18N = True

# USE_L10N = True

# USE_TZ = True

# REST_FRAMEWORK = {
#     "DEFAULT_PERMISSION_CLASSES": ["rest_framework.permissions.AllowAny"],
#     "DEFAULT_RENDERER_CLASSES": ["rest_framework.renderers.JSONRenderer",],
#     "DEFAULT_PARSER_CLASSES": ["rest_framework.parsers.JSONParser",],
# }
import os
import json

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def get_secret_json_value(file_path, key, default=None):
    try:
        with open(file_path, "r") as f:
            data = json.load(f)
            return data.get(key, default)
    except Exception:
        return default

BASE_SECRET_PATH = "/mnt/secrets"

SECRET_KEY = get_secret_json_value(f"{BASE_SECRET_PATH}/SECRET_KEYYYa", "SECRET_KEY")

DEBUG_str = get_secret_json_value(f"{BASE_SECRET_PATH}/is_debuga", "DEBUG", default="false")
DEBUG = DEBUG_str.lower() == "true"

ALLOWED_HOSTS = ["*"]

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "rest_framework",
    "api",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "app.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "app.wsgi.application"

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": get_secret_json_value(f"{BASE_SECRET_PATH}/is_database_namea", "DATABASE_NAME"),
        "USER": get_secret_json_value(f"{BASE_SECRET_PATH}/is_database_usera", "DATABASE_USER"),
        "PASSWORD": get_secret_json_value(f"{BASE_SECRET_PATH}/is_database_passworda", "DATABASE_PASSWORD"),
        "HOST": get_secret_json_value(f"{BASE_SECRET_PATH}/is_database_hosta", "DATABASE_HOST", default="localhost"),
        "PORT": get_secret_json_value(f"{BASE_SECRET_PATH}/is_database_porta", "DATABASE_PORT", default="5432"),
    }
}

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator", },
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator", },
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator", },
]

LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_L10N = True

USE_TZ = True

REST_FRAMEWORK = {
    "DEFAULT_PERMISSION_CLASSES": ["rest_framework.permissions.AllowAny"],
    "DEFAULT_RENDERER_CLASSES": ["rest_framework.renderers.JSONRenderer",],
    "DEFAULT_PARSER_CLASSES": ["rest_framework.parsers.JSONParser",],
}
