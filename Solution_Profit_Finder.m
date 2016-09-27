function Solution_Profit_Finder

number_iteration=10000;
DATA=dlmread('Instance_and_Result_Nested_logit_n2.txt'); %All instances in a DATA file should have the same mu (Poisson mean)
[Row_s, ~]=size(DATA);
Start_number=1; End_number=Row_s; number_instances=End_number-Start_number+1;% range of instances to run
DATA=DATA(Start_number:End_number,:);

% pre-allocation
n=DATA(1,2); % number of products
Solution_R1=zeros(number_instances,n); Upper_R1=zeros(number_instances,1); Profit_R1_SIM=zeros(number_instances,2); Time_R1=zeros(number_instances,2);

for z=Start_number:End_number
    % read data for instance z
    j=3; mu=DATA(z,j); j=j+1; % Poisson mean
    r(1:n)=DATA(z,j:j+n-1); j=j+n; % marginal revenue vector
    c(1:n)=DATA(z,j:j+n-1); j=j+n; % marginal cost vector
    a(1:n+1)=DATA(z,j:j+n); j=j+n+1; % attraction value vector 
    Nest_info(1:n+1)=DATA(z,j:j+n); j=j+n+1; % nest information specifying the nest for each product (from 0 to n) 
    N_nest=DATA(z,j); j=j+2; % number of total nests
    Lambda=DATA(z,j); % lambda for nested logit model
    
    Num_Customer=poissrnd(mu,[1,number_iteration]); % random number of customers; We actually preset this for the paper: load('Num_Customer.mat')
    Prob=Choice_Prob_Calculator_Nested_logit(n, a, Nest_info, N_nest, Lambda); % choice probability calculation

    % Method R1 solution and upper bound
    tic; [Solution_R1(z,:),Upper_R1(z,1)]=Method_R1(n,mu,r,c,Prob); Time_R1(z,1)=toc;
    % Method R1 simulated profit 
    tic; Profit_R1_SIM(z,1:2)=Profit_simulator(n, r, c, Prob, round(Solution_R1(z,:)), number_iteration, Num_Customer); Time_R1(z,2)=toc;

end;
Result=[DATA  Solution_R1 Upper_R1 Profit_R1_SIM Time_R1];
dlmwrite('Instance_and_Result_Nested_logit_n2_TEST.txt', Result, 'delimiter', ' ', 'newline', 'pc')