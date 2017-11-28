function [s, obj_opt] = get_structral_shocks_alternative(A,gamma,resid,which_shocks)

nvar = size(gamma,1);
D_vec_zero = ones(nvar*(nvar-size(gamma,2)), 1);
objective_zero = obj_get_struct_shocks_alt(D_vec_zero,gamma,which_shocks);
objective_fun = @(D_vec) obj_get_struct_shocks_alt(D_vec,gamma,which_shocks);

%Optimization Parameters
%             options  = optimset('fmincon');
%             options  = optimset(options, 'TolFun', 1e-5, 'display', 'none', 'MaxIter', 1000 );
options  = optimoptions('fmincon', 'TolFun', 1e-9, 'display', 'none', 'MaxIter', 1000, ...
    'StepTolerance',1.0000e-15, 'ConstraintTolerance', 1.0000e-09, 'Algorithm', 'sqp' );
D_vec_opt = fmincon(objective_fun, D_vec_zero,[],[],[],[],[],[],[],options);
obj_opt = obj_get_struct_shocks_alt(D_vec_opt,gamma,which_shocks);

for i_var = 1:nvar
      if i_var == which_shocks(1) 
            D(:,i_var) = gamma(:,1);
      elseif i_var == which_shocks(2)
            D(:,i_var) = gamma(:,2);
      else
            D(:,i_var) = D_vec((i_var*nvar)+1-nvar-(nvar*size(gam,2)):i_var*nvar-(nvar*size(gam,2)));
      end
end
% D(:,1) = D_vec_opt(1:nvar);
% D(:,2) = D_vec_opt(nvar+1:2*nvar);
% D(:,3) = gamma(:,1);
% D(:,4) = gamma(:,2);
% D(:,5) = D_vec_opt(2*nvar+1:3*nvar);
% D(:,6) = D_vec_opt(3*nvar+1:end);



s = (A*D)\resid';

identity = s*s'./size(resid,1);
if sum(sum(abs(identity - eye(nvar)))) > 10^(-6)
    warning(' s*s'' not equal to identity')
end

end