jacob = @(a,r,h) [-0.5*(2*a+1)*r*h^2 + r*h - (1+h)^(-a)*log(1+h), -0.5*(a^2+a)*h^2 + a*h - (1-(1+h)^(-a)), -(a^2+a)*r*h + a*r - a*(1+h)^(-a-1);
  -(2*a+1)*r*h^2+r*h*(1-(1+h)^(-a-1))+a*r*h*(1+h)^(-a-1)*log(1+h), -(a^2+a)*h^2 + a*h*(1-(1+h)^(-a-1)), -2*(a^2+a)*r*h + a*r*(1-(1+h)^(-a-1)) + a*r*h*(a+1)*(1+h)^(-a-2);
  -(2*a+1)*r*h^2*(1-(1+h)^(-a-2)) - (a^2+a)*r*h^2*(1+h)^(-a-2)*log(1+h), -(a^2+a)*h^2*(1-(1+h)^(-a-2)), -(a^2+a)*r*(2*h*(1-(1+h)^(-a-2)) + (a+2)*h^2*(1+h)^(-a-3))];
