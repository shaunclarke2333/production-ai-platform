# The logging module flow

# Logger:
# It's job is to schedule the log information for output.
# The logger sends it to a handler depending on the type
# of output. a logger can have multiple handlers for specific
# output. i.e handler for file output handler for stdout/stderr


# Handler:
# The handler's job is to send the log information to an
# output. Each handler has a formatter attached to it.
# The formmater's job is to shape the output

# Formatter:
# Each handler has a formatter attached to it.
# The formatter determines what parts of the log information.
# will be displayed and how.


import logging
from ..config import settings
from pythonjsonlogger.json import JsonFormatter


def setup_logging() -> None:

    # Defining stream handler that will allow us to stream logs to stdout\stderr
    console_handler: logging.StreamHandler = logging.StreamHandler()
    # Adding the JSON formatter with timestamp and log level to the stream handler.
    # To format log output as json

    console_handler.setFormatter(
        JsonFormatter("%(asctime)s %(levelname)s %(name)s %(message)s")
    )
    # Defining the root logger
    root_logger: logging.Logger = logging.getLogger()
    # Explicitly grabbing uvicorn's loggers and redirecting them
    # This has to be done because uvicorn creates its own logger and handlers
    # So this way the uvicorn logs will also be structured and machine parseable
    for name in ("uvicorn", "uvicorn.access", "uvicorn.error"):
        uvicorn_logger = logging.getLogger(name)  # Get the uvicorn logger
        uvicorn_logger.handlers.clear()  # Drop each handler
        uvicorn_logger.propagate = (
            True  # Telling each uvicorn handler to let records flow up to my custom logger.

        )
    # Clearing any preexisting handlers
    root_logger.handlers.clear()
    # Addng the handler that will be used with the logger
    root_logger.addHandler(console_handler)
    # Setting the logging level
    root_logger.setLevel(settings.log_level.upper())
