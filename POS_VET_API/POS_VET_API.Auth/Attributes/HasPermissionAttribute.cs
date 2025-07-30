using Microsoft.AspNetCore.Authorization;
namespace POS_VET_API.Auth.Attributes
{
    public sealed class HasPermissionAttribute(string permission)
        : AuthorizeAttribute(permission)
    {
    }
}
