function Result=Profit_simulator(n, r, c, Prob, initial_inventory_level, number_iteration, Num_Customer)

Rand_number=rand(number_iteration,10000); % random number for customer choice; We actually preset this for the paper in Rand_numbers.mat to allow uniform comparison across different methods load('Rand_numbers.mat')
profit=zeros(number_iteration,1);
S_index=de2bi((0:2^n-1)','left-msb'); % index for the assortsments: each row corresponds to an assortment.

for y=1:number_iteration
    inventory_level=initial_inventory_level;
    num_customer=Num_Customer(y);
    if num_customer==0
        profit(y)=-initial_inventory_level*c';
    else
        J_X=(inventory_level>0);
        if sum(J_X)==0
            Cum_Choice_P=zeros(1,n);
        else
            Choice_P=Prob(find(ismember(S_index,J_X,'rows'),1),:);
            Cum_Choice_P=cumsum(Choice_P);
        end;
        for u=1:num_customer
            Rand_num=Rand_number(y,u);
            Customer_Choice=0;
            if Rand_num<=Cum_Choice_P(n)
                Customer_Choice=find(Cum_Choice_P>=Rand_num,1);
            end;
            if Customer_Choice > 0
                inventory_level(Customer_Choice)=inventory_level(Customer_Choice)-1;
                if inventory_level(Customer_Choice)==0;
                    J_X=(inventory_level>0);
                    if sum(J_X)==0
                        Cum_Choice_P=zeros(1,n);
                    else
                        Choice_P=Prob(find(ismember(S_index,J_X,'rows'),1),:);
                        Cum_Choice_P=cumsum(Choice_P);
                    end;
                end;
            end;
        end;
        sales=initial_inventory_level-inventory_level;
        profit(y)=sales*r'-initial_inventory_level*c';
    end;
end;
Expected_Profit=sum(profit)/number_iteration;
Std=std(profit);
Result=[Expected_Profit Std];