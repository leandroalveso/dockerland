from fastapi import APIRouter, Depends
from fastapi_limiter.depends import RateLimiter

from app.services.gateways.apis.users.routes import (
    router as users_router
)

router = APIRouter()

@router.get(
    "/rate_limit",
    dependencies=[Depends(RateLimiter(times=2, seconds=5))]
)
def test_rate_limit():
    return {"Hello": "This is a  rate limited endpoint!"}

router.include_router(
    users_router, prefix="/users", tags=["User"]
)
