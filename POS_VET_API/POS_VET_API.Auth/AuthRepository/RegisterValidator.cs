//using FluentValidation;
//using POS_VET_API.DataAccess.DTOs;
//using POS_VET_API.DataAccess.Models;

//namespace POS_VET_API.Auth.AuthRepository
//{
//    public class RegisterValidator : AbstractValidator<UserRegistrationDto>
//    {
//        public RegisterValidator(IUsersAuth usersAuthServices)
//        {
//            RuleFor(x => x.Email)
//                .Must((email, _) =>
//            {
//                return usersAuthServices.IsEmailUnique(email);
//            }).When(x => x.Email is not null).
//            WithMessage("User with this email already exist. ");
//            RuleFor(x => x.Password)
//                .MinimumLength(8)
//                .MaximumLength(15)
//                .NotEmpty()
//                .NotNull();

//            RuleFor(x => x.BirthDate)
//                 .Must(date => date != DateTime.Today
//                 && date <= DateTime.Today.AddYears(-18))
//                 .WithMessage("The date of birth cannot be today and must correspond to a person over 18 years of age. ");
//        }
//    }
//}
