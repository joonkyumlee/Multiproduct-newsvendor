function [Solution, Max_Profit]=Method_ABS(n, mu, r, c, Prob)

% Input arguments: n=number of products, mu=Poisson mean, r=marginal revenue vector, c=marginal cost vector, Prob=Choice probability matrix

Fractile=(r-c)./r;  % critical fractile vector
Solution=zeros(2^n,n); % stocking solution initialization
E_Profit_Component=zeros(2^n,n); % expected profit calculation component initialization

for i=1:2^n % interate over all assortments
    for j=1:n
        if Prob(i,j)>0
            Solution(i,j)=poissinv(Fractile(j),mu*Prob(i,j)); % newsvendor solution
        end;
        Left=((0:Solution(i,j))-Solution(i,j))*poisspdf((0:Solution(i,j))',mu*Prob(i,j));
        E_Profit_Component(i,j)=(r(j)-c(j))*Solution(i,j) + r(j)*Left; % expected profit for assortment i product j 
    end;
end;
[Max_Profit,Subset_Num]=max(sum(E_Profit_Component,2));
Solution=Solution(Subset_Num,:);