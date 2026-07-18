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


def setup_logging():

    # Defining stream handler that will allow us to stream logs to stdout
    console_handler = logging.StreamHandler()
    # Adding the JSON formatter with timestamp and log level to the stream handler
    console_handler.setFormatter(
        JsonFormatter("%(asctime)s %(levelname)s %(name)s %(message)s")
    )
    # Defining the root logger
    root_logger = logging.getLogger()
    # Explicitly grabbing uvicorn's loggers and redirecting them
    # This has to be done because uvicorn creates its own logger and handlers
    # So this way the framewoek logs will also be structured and machine parseable
    for name in ("uvicorn", "uvicorn.access", "uvicorn.error"):
        uvicorn_logger = logging.getLogger(name)  # Get the uvicorn logger
        uvicorn_logger.handlers.clear()  # Drop all of uvicorn's handlers
        uvicorn_logger.propagate = (
            True  # Telling the uviconr handler to let records flow up.
        )
    # Clearing any preexisting handlers
    root_logger.handlers.clear()
    # Addng the handler that will be used with the logger
    root_logger.addHandler(console_handler)
    # Setting the logging level
    root_logger.setLevel(settings.log_level.upper())
