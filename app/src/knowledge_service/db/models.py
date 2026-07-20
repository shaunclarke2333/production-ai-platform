# All models in this file will inherrit from the Base class in the base.py file.
# SQLAlchecmy knows the Base subclasses should be treated as tables.

from sqlalchemy.orm import Mapped, mapped_column
from datetime import datetime
from sqlalchemy import DateTime, func
from .base import Base

class Incident(Base):
    __tablename__ = "incidents"

    id: Mapped[int] = mapped_column(primary_key=True)
    title: Mapped[str]
    description: Mapped[str]
    service: Mapped[str]
    severity: Mapped[str]
    resolution: Mapped[str | None]
    occurred_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now()) #auto timestamp