function Prob=Choice_Prob_Calculator_Nested_logit(n, p_i, Nest_info, N_nest, Lambda)

for i=1:n+1
    V(i)=Lambda*log(p_i(i))+(1-Lambda)*log(sum(p_i(Nest_info==Nest_info(i))));
end;
e_V_L=exp(V/Lambda);

for i=1:N_nest
    Nest(i,:)=(Nest_info==i);
end;

S_index=de2bi((0:2^n-1)','left-msb');
S_index_extended=[ones(2^n,1) S_index];

for i=1:2^n
    Part_sum=(e_V_L.*S_index_extended(i,:))*Nest';
    Part_sum_L=(Part_sum(Part_sum>0)).^Lambda;
    Deno=sum(Part_sum_L);
    Part_sum_L_1=Part_sum.^(Lambda-1);
    Part_sum_L_1(Part_sum_L_1==inf)=0;
    Numer=(e_V_L.*S_index_extended(i,:)).*(Part_sum_L_1*Nest);
    Prob(i,:)=Numer/Deno;
end;

Prob=Prob(:,2:end);



   