function [Solution,E_Profit]=Method_R1(n,mu,r,c,Prob)
%Input arguments: n=number of products, mu=Poisson mean, r=marginal revenue vector, c=marginal cost vector, Prob=Choice probability matrix

%%% Window-shopper decomposition %%%
Alpha=min(1-sum(Prob(2:2^n,:),2)); % Proportion of Window-shoppers 
mu_Alpha=mu*(1-Alpha); % Window-shopper adjusted Poisson mean
Prob_Alpha=Prob/(1-Alpha); % Window-shopper adjusted choice probability matrix
Overage_Alpha=-Prob_Alpha*c'; % Window-shopper adjusted overage value vector
Underage_Alpha=Prob_Alpha*(r-c)'; % Window-shopper adjusted underage value vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_S=2^n; % Number of assortments
j=1;
[Gamma(j), Opt_q(j)]=max(Underage_Alpha./(Underage_Alpha+abs(Overage_Alpha))); %Initialization
Gamma_Candi=Gamma(1);

while Gamma_Candi>0
    j=j+1;
    Underage_minus=(Underage_Alpha-repmat(Underage_Alpha(Opt_q(j-1)),n_S,1));
    Overage_minus=(Overage_Alpha-repmat(Overage_Alpha(Opt_q(j-1)),n_S,1));
    % Algorithm 5 Step 2
    [Gamma_Candi, Opt_q_Candi]=max((Underage_minus.*(Underage_minus>0))./(Underage_minus.*(Underage_minus>0)-(Overage_minus.*(Overage_minus<0))));
    if Gamma_Candi>0
        Opt_q(j)=Opt_q_Candi;
        Gamma(j)=Gamma_Candi;
    end;
end;
[~,N_epoch]=size(Gamma); % Number of distict Gamma's

z=1;
for i=N_epoch:-1:1
    while (poisscdf(z-1,mu_Alpha)<= (Gamma(i)))
        Profit(z)=(1-poisscdf(z-1,mu_Alpha))*(Underage_Alpha(Opt_q(i))+abs(Overage_Alpha(Opt_q(i))))+Overage_Alpha(Opt_q(i)); % Profit calculation
        q(z,:)=Prob_Alpha(Opt_q(i),:); % Solution calculation
        z=z+1;
    end;
end;
E_Profit=sum(Profit);
Solution=sum(q,1);