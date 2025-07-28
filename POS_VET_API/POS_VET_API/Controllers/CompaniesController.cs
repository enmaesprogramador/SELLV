using Gridify;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using POS_VET_API.DataAccess.Models;
using POS_VET_API.DataAccess.Repository;
using POS_VET_API.Utils.ResponseObject;
using System.Runtime.CompilerServices;

namespace POS_VET_API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CompaniesController : ControllerBase
    {
        private readonly ICompanyRepository _companyRepository;

        public CompaniesController(ICompanyRepository companyRepository)
        {
            _companyRepository = companyRepository;
        }

        [HttpGet, Authorize]
        public ActionResult<ResultPattern<Paging<Company>>> GetCompanies([FromQuery] GridifyQuery query)
            => Ok(_companyRepository.GetAll(query));


        [HttpGet("{id:int}"), Authorize]
        public ActionResult<ResultPattern<Paging<Company>>> GetCompany(int id)
            => Ok(_companyRepository.Get(x => x.Id == id));

        [HttpPost, Authorize]
        public ActionResult<ResultPattern<Paging<Company>>> CreateCompany([FromBody] Company company)
            => Created(string.Empty, _companyRepository.Post(company));

        [HttpPut, Authorize]
        public ActionResult<ResultPattern<Paging<Company>>> UpdateCompany(int id, [FromBody] Company company)
            => Ok(_companyRepository.Update(x => x.Id == id, company));
        
    }
}
