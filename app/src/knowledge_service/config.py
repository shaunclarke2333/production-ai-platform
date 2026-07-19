# Pydantic is a Python data validation library that uses type hints to validate
# and parse data at runtime. Think of it as enforcing type hints.
# It doesn't just check types: it coerces input into
# the declared type where it can (the string "8000" becomes the int 8000) and
# raises a clear error where it can't.
#
# Its role is to guard the boundaries of the app like a bouncer. It turns untrusted external
# input (env vars, request bodies, JSON) into clean, typed, trusted Python
# objects, so code past that boundary never has to second-guess its data.


# Pydantic-settings

from pydantic_settings import BaseSettings, SettingsConfigDict
from typing import Literal, ClassVar



class Settings(BaseSettings):
    # Application name
    app_name: str = "knowledge-service"

    # environment name. Using Literal to specify the know values
    # So all anything not listed will be rejected
    environment: Literal["dev", "test", "prod"]

    # loglevel to set to warning. Using Literal to specify the know values
    # So all anything not listed will be rejected
    log_level: Literal["debug", "info", "warning", "error"] = "info"

    # The URL for the database string
    database_url: str

    # Specifying the .env file to point to using SettingsConfigDict.
    # The .env file will hold local config files fro each environment (dev, prod, test)
    model_config: ClassVar[SettingsConfigDict] = SettingsConfigDict(env_file=".env")


# Creating the settings object that will be imported and used in the project.
settings: Settings = Settings()
