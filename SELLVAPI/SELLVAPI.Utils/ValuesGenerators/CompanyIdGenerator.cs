using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.ValueGeneration;

namespace SELLVAPI.Utils.ValuesGenerators
{
    public class CompanyIdGenerator : ValueGenerator<int>
    {
        public override bool GeneratesTemporaryValues => false;

        public override int Next(EntityEntry entry)
            => Convert.ToInt32(entry.Context.GetService<IHttpContextAccessor>().HttpContext.User.FindFirst("CompanyId").Value);
    }
}
