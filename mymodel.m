function [result] = mymodel(x1,x2)

%Function takes x1 and x2

result = 0;

if x1 > 0 & x2 > 0;

result = x1/x2;

%elseif x1 == 0;

%result = 0;

%elseif x2 == 0;

%result = 0;

elseif x1 > 0 | x2 > 0;

result = (2*x1)/x2;

elseif x1 < 0 & x2 <0;

result = x2/x1;

else

result = 0;

end

if result == inf

result = 0

elseif result == NaN
    
    result = 0
    
end