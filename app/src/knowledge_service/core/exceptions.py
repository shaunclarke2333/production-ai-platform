# The idea here is separation of concerns.

# The service layer (the code that fetches an incident) should be able to
# say "incident not found" without knowing anything about HTTP. That's not
# its job. Its job is to fetch an incident, or report that it wasn't found.

# Two separate pieces make this work:

# 1. The custom exception (below) is a plain domain error the service layer
#    raises. It lives in the service's world and knows nothing about HTTP.
#    Thats like a kitchen saying "we're out of salmon."

# 2. A separate exception handler, registered at the FastAPI boundary,
#    catches that exception and translates it into something the HTTP client
#    understands: a 404 with a clean JSON message. The waiter turning
#    "out of salmon" into an apology to the customer.

# The service does what it was built to do; the handler owns the translation
# of the service's domain errors into a language that FastAPI HTTP client can understand.


class KnowledgeServiceError(Exception):
   """
   This is a base class for all knowledge service domain errors
   """
   pass



class IncidentNotFoundError(KnowledgeServiceError):
    """
    This class is raised when an incodent with the given ID does not exist

    It also carries holds the incident ID so the API layer can build a 404 response.
    """
    def __init__(self, incident_id: int) -> None:
        self.incident_id = incident_id
        # Creating the incident message
        self.message: str =  f"Incident {self.incident_id} not found"

        super().__init__(self.message)
        