using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using SELLVAPI.Utils.Exceptions;
using SELLVAPI.Utils.ResponseObjects;
using System.Net;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace SELLVAPI.MiddleWares
{
    public class GlobalExceptionHandlerMiddleware : IExceptionHandler
    {
        // Opciones para la serializacion: 
        private static JsonSerializerOptions JsonSerializerOptions => new()
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
            PropertyNameCaseInsensitive = true,
            ReferenceHandler = ReferenceHandler.IgnoreCycles,
            NumberHandling = JsonNumberHandling.AllowReadingFromString | JsonNumberHandling.WriteAsString
        };

        public async ValueTask<bool> TryHandleAsync(
            HttpContext httpContext,
            Exception exception,
            CancellationToken cancellationToken)
        {
            ResultPattern<ProblemDetails> problemDetails = new();
            var exType = exception.GetType();
            HttpStatusCode httpStatusCode = HttpStatusCode.InternalServerError;
            CheckException(httpContext, exception, out problemDetails, exType, out httpStatusCode);
            var response = JsonSerializer.Serialize(problemDetails, JsonSerializerOptions);
            //LoggerClass.LogError(response);
            httpContext.Response.ContentType = "application/json";
            httpContext.Response.StatusCode = (int)httpStatusCode;
            await httpContext.Response.WriteAsync(response, cancellationToken);
            return true;
        }

        private static void CheckException(
            HttpContext httpContext,
            Exception exception,
            out ResultPattern<ProblemDetails> problemDetails,
            Type exType,
            out HttpStatusCode httpStatusCode)
        {
            if (exType == typeof(BadRequestException))
            {
                var details = new ResultPattern<ProblemDetails>
                {
                    Message = exception.Message,
                    StatusCode = StatusCodes.Status400BadRequest,
                    IsSuccess = false
                };
                httpStatusCode = HttpStatusCode.BadRequest;
                problemDetails = details;
            }
            else if (exType == typeof(UnauthorizedException))
            {
                var details = new ResultPattern<ProblemDetails>
                {
                    Message = exception.Message,
                    StatusCode = StatusCodes.Status400BadRequest,
                    IsSuccess = false

                };
                httpStatusCode = HttpStatusCode.Unauthorized;
                problemDetails = details;

            }
            else if (exType == typeof(NotFoundException))
            {
                var details = new ResultPattern<ProblemDetails>
                {
                    Message = exception.Message,
                    StatusCode = StatusCodes.Status400BadRequest,
                    IsSuccess = false
                };
                httpStatusCode = HttpStatusCode.NotFound;
                problemDetails = details;

            }
            else
            {
                var details = new ResultPattern<ProblemDetails>
                {
                    Message = exception.Message,
                    StatusCode = StatusCodes.Status500InternalServerError,
                    IsSuccess = false
                };
                httpStatusCode = HttpStatusCode.InternalServerError;
                problemDetails = details;
            }
        }
    }
}
