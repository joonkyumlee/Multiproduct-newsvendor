function [Solution, E_Profit]=Method_R2(n,mu, r, c, Prob)
% Input arguments: n=number of products, mu=Poisson mean, r=marginal revenue vector, c=marginal cost vector, Prob=Choice probability matrix

Fractile=(r-c)./r; % critical fractile vector
Prob=max(Prob); % maximum choice probability vector
Solution=zeros(1,n); % stocking solution initialization
Value=zeros(1,n); % expected profit for each product initialization

for j=1:n
    if Prob(j)>0
        Solution(j)=poissinv(Fractile(j),mu*Prob(j)); % newsvendor solution
    end;
    Left=((0:Solution(j))-Solution(j))*poisspdf((0:Solution(j))',mu*Prob(j));
    Value(j)=(r(j)-c(j))*Solution(j) + r(j)*Left; % expected profit for each product 
end;
E_Profit=sum(Value); % sum of expected profits


