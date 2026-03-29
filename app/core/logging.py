from __future__ import annotations

import logging
import sys

import structlog
import structlog.types

from app.core.config import settings


def _level_to_int(name: str) -> int:
    """Map Settings log level name to int.

    Avoid ``logging.getLevelName(str)``: on Python 3.11+ it does not return an int.
    """
    return logging.getLevelNamesMapping().get(name.upper(), logging.INFO)


def _add_service(
    _logger: object,
    _method_name: str,
    event_dict: dict[str, object],
) -> dict[str, object]:
    event_dict["service"] = settings.SERVICE_NAME
    return event_dict


def configure_logging() -> None:
    """Configure structlog once at process startup (e.g. FastAPI lifespan).

    Dev: colored ConsoleRenderer. Prod: JSON for log aggregators.

    Uses ``PrintLoggerFactory``-compatible processors only — stdlib
    ``add_logger_name`` / ``add_log_level`` require ``LoggerFactory``, not PrintLogger.
    """
    min_level = _level_to_int(settings.LOG_LEVEL)

    shared_processors: list[structlog.types.Processor] = [
        structlog.contextvars.merge_contextvars,
        structlog.processors.add_log_level,
        structlog.processors.StackInfoRenderer(),
        structlog.processors.TimeStamper(fmt="iso", utc=True),
        _add_service,
        structlog.processors.format_exc_info,
        structlog.processors.UnicodeDecoder(),
    ]

    renderer: structlog.types.Processor = (
        structlog.processors.JSONRenderer()
        if settings.ENVIRONMENT == "production"
        else structlog.dev.ConsoleRenderer(colors=True)
    )

    structlog.configure(
        processors=[
            *shared_processors,
            renderer,
        ],
        wrapper_class=structlog.make_filtering_bound_logger(min_level),
        context_class=dict,
        logger_factory=structlog.PrintLoggerFactory(file=sys.stdout),
        cache_logger_on_first_use=True,
    )

    logging.basicConfig(
        format="%(message)s",
        stream=sys.stdout,
        level=min_level,
    )
    for name in ("uvicorn", "uvicorn.error", "uvicorn.access", "sqlalchemy.engine"):
        lg = logging.getLogger(name)
        lg.handlers.clear()
        lg.propagate = True
