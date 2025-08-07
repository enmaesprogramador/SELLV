using Gridify;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SELLVAPI.DataAccess.Models;
using SELLVAPI.DataAccess.Repository;
using SELLVAPI.Utils.ResponseObjects;

namespace SELLVAPI.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class CompaniesController : ControllerBase
    {
        private readonly ICompanyRepository _companyRepository;

        public CompaniesController(ICompanyRepository companyRepository)
        {
            _companyRepository = companyRepository;
        }

        [HttpGet]
        public ActionResult<ResultPattern<Paging<Company>>> GetCompanies([FromQuery] GridifyQuery query)
            => Ok(_companyRepository.GetAll(query));


        [HttpGet("{id:int}")]
        public ActionResult<ResultPattern<Paging<Company>>> GetCompany(int id)
            => Ok(_companyRepository.Get(x => x.Id == id));

        [HttpPost]
        public ActionResult<ResultPattern<Paging<Company>>> CreateCompany([FromBody] Company company)
            => Created(string.Empty, _companyRepository.Post(company));

        [HttpPut]
        public ActionResult<ResultPattern<Paging<Company>>> UpdateCompany(int id, [FromBody] Company company)
            => Ok(_companyRepository.Update(x => x.Id == id, company));

    }
}
