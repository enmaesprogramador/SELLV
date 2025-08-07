using Gridify;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using SELLVAPI.DataAccess.Models;
using SELLVAPI.Utils.AppConstants;
using SELLVAPI.Utils.Exceptions;
using SELLVAPI.Utils.ResponseObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SELLVAPI.DataAccess.Repository
{
    public interface IGenericInterface<T> where T : class
    {
        ResultPattern<T> Get(Func<T, bool> predicate);
        ResultPattern<Paging<T>>? GetAll(GridifyQuery query);
        ResultPattern<T> Post(T entity);
        ResultPattern<T> Update(Func<T, bool> predicate, T entity);
        ResultPattern<T> Delete(Func<T, bool> predicate);
    }

    public abstract class GenericRepository<T> : IGenericInterface<T> where T : class
    {
        private readonly SELLVDBContext _DBContext;
        private readonly IHttpContextAccessor? _httpContextAccesor;
        public GenericRepository(SELLVDBContext DBContext, IHttpContextAccessor httpContextAccesor)
        {
            _DBContext = DBContext;
            _httpContextAccesor = httpContextAccesor;
        }
        public GenericRepository(SELLVDBContext DBContext)
        {
            _DBContext = DBContext;
        }
        public virtual ResultPattern<T> Delete(Func<T, bool> predicate)
        {
            var entityToDelete = _DBContext.Set<T>().FirstOrDefault(predicate)
                ?? throw new NotFoundException(AppConstants.NOT_FOUND_MESSAGE);
            _DBContext
                .Set<T>()
                .Remove(entityToDelete!);

            _DBContext.SaveChanges();
            return ResultPattern<T>.Success(entityToDelete!, StatusCodes.Status200OK, AppConstants.DATA_DELETED_MESSAGE);
        }
        public virtual ResultPattern<T> Get(Func<T, bool> predicate)
        {
            var entity = _DBContext.Set<T>()
                .AsNoTrackingWithIdentityResolution()
                .FirstOrDefault(predicate)
                ?? throw new NotFoundException(AppConstants.NOT_FOUND_MESSAGE);

            return ResultPattern<T>.Success(entity!,
                StatusCodes.Status200OK,
                AppConstants.DATA_OBTAINED_MESSAGE);
        }
        public virtual ResultPattern<Paging<T>> GetAll(GridifyQuery query)
        {
            /*           string? companyId, branchId;
            companyId = _httpContextAccesor
                .HttpContext?
                .Items["CompanyId"] as string ??
                string.Empty;

            branchId = _httpContextAccesor
                .HttpContext?
                .Items["BranchOfficeId"] as string ??
                string.Empty;

            if (string.IsNullOrEmpty(companyId))
            {
                return ResultPattern<Paging<T>>.Success(new Paging<T>(),
                    StatusCodes.Status401Unauthorized,
                    "This user isn't in a company. ");
            }

            if (typeof(T).GetProperty("CompanyId") is not null &&
                typeof(T).GetProperty("BranchOfficeId") is not null)
            {
                var entitiesByCompAndBranch = _DBContext.Set<T>()
                    .AsNoTrackingWithIdentityResolution()
                    .Where(x => EF.Property<int>(x, "CompanyId") == int.Parse(companyId!) &&
                    EF.Property<int>(x, "BranchOfficeId") == int.Parse(branchId!))
                    .ApplyFilteringAndOrdering(query);

                var responseComBr = new Paging<T>
                {
                    Data = entitiesByCompAndBranch,
                    Count = entitiesByCompAndBranch.Count()
                };

                if (responseComBr.Count == 0)
                    return ResultPattern<Paging<T>>.Success(new Paging<T>(),
                                       StatusCodes.Status400BadRequest,
                                       "No hay datos en tu sucursal. ");

                return ResultPattern<Paging<T>>.Success(responseComBr,
                                       StatusCodes.Status200OK,
                                       AppConstants.DATA_OBTAINED_MESSAGE);
            }
            if (typeof(T)
                .GetProperty("BranchOfficeId") is not null)
            {
                var entitiesComp = _DBContext.Set<T>()
                    .AsNoTrackingWithIdentityResolution()
                    .Where(x => EF.Property<int>(x, "CompanyId") == int.Parse(companyId!))
                    .ApplyFilteringAndOrdering(query);

                var responseComp = new Paging<T>
                {
                    Data = entitiesComp,
                    Count = entitiesComp.Count()
                };
                return ResultPattern<Paging<T>>.Success(responseComp,
                    StatusCodes.Status200OK,
                    AppConstants.DATA_OBTAINED_MESSAGE);
            }*/

            var entities = _DBContext.Set<T>()
                .AsNoTrackingWithIdentityResolution()
                .ApplyFilteringOrderingPaging(query);

            var totalItems = _DBContext.Set<T>()
                .AsNoTrackingWithIdentityResolution()
                .ToList();

            var responseEntities = new Paging<T>
            {
                Data = entities,
                Count = totalItems.Count
            };

            return ResultPattern<Paging<T>>.Success(responseEntities,
                    StatusCodes.Status200OK,
                    AppConstants.DATA_OBTAINED_MESSAGE);
        }
        public virtual ResultPattern<T> Post(T entity)
        {
            _DBContext.Set<T>().Add(entity);
            _DBContext.SaveChanges();
            return ResultPattern<T>.Success(entity,
                StatusCodes.Status201Created,
                AppConstants.DATA_SAVED_MESSAGE);
        }
        public virtual ResultPattern<T> Update(Func<T, bool> predicate,
            T updatedEntity)
        {
            var entityToUpdate = _DBContext
                .Set<T>()
                .AsTracking()
                .FirstOrDefault(predicate)
                ?? throw new NotFoundException(AppConstants.NOT_FOUND_MESSAGE);
            /*var createdBy = entityToUpdate
                .GetType()
                .GetProperty("CreatedBy");

            if (createdBy is not null)
                createdBy.GetValue(entityToUpdate)?
                         .ToString();

            var createdAt = entityToUpdate
                .GetType()
                .GetProperty("CreatedAt");

            if (createdAt is not null)
                createdAt.GetValue(entityToUpdate)?
                         .ToString();

            DateTime? dateCreatedAt = Convert.ToDateTime(createdAt);

            updatedEntity
                .GetType()
                .GetProperty("CreatedBy")?
                .SetValue(updatedEntity, createdBy);
             
            updatedEntity
                .GetType()
                .GetProperty("CreatedAt")?
                .SetValue(updatedEntity, dateCreatedAt);*/

            _DBContext.Entry(entityToUpdate)
                .CurrentValues
                .SetValues(updatedEntity);
            _DBContext.Update(entityToUpdate);
            _DBContext.SaveChanges();
            return ResultPattern<T>.Success(entityToUpdate,
                StatusCodes.Status200OK,
                AppConstants.DATA_UPDATED_MESSAGE);
        }
    }

}
