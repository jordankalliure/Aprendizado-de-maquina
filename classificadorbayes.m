%%%%%%%%%%%%%%%%%%%% Trabalho 2 %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%       Classificador de Naive-Bayes         %%%%%%%%%
%%%%   Aluno:Jordan Kalliure Souza Carvalho     %%%%%%%%%
%%%%      Disciplina: Aprendizado de Máquina    %%%%%%%%%
%%%%              Período: 2021/1               %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; clc; close all;

%%%% Carregando Base de dados %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Xn,classe]=xlsread('iris_dataset.xlsx');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Criando variáveis e características %%%%%%%%%%%%%%%%

X1=Xn(:,1);
X2=Xn(:,2);
X3=Xn(:,3);
X4=Xn(:,4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Obtenção da classe para números %%%%%%%%%%%%%%%%%%%
clas = classe(2:151,5);
classnum = zeros(150,1);
for i=1:150
    switch cell2mat(clas(i))
        case 'setosa'
            classnum(i)=1;
        case 'versicolor'
            classnum(i)=2;
        case 'virginica'
            classnum(i)=3;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Variáveis dispersas em validação cruzada %%%%%%%%
X1_train1 = X1(1:30);X1_train2 = X1(31:60);X1_train3 = X1(61:90);X1_train4 = X1(91:120);X1_train5 = X1(121:150);
X2_train1 = X2(1:30);X2_train2 = X2(31:60);X2_train3 = X2(61:90);X2_train4 = X2(91:120);X2_train5 = X2(121:150);
X3_train1 = X3(1:30);X3_train2 = X3(31:60);X3_train3 = X3(61:90);X3_train4 = X3(91:120);X3_train5 = X3(121:150);
X4_train1 = X4(1:30);X4_train2 = X4(31:60);X4_train3 = X4(61:90);X4_train4 = X4(91:120);X4_train5 = X4(121:150);
clas1 = classnum(1:30);clas2 = classnum(31:60);clas3 = classnum(61:90);clas4 = classnum(91:120);clas5 = classnum(121:150);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%              Pasta 1                     %%%%%%%%
pasta_x1 = [X1_train1; X1_train2; X1_train3; X1_train4];
pasta_x2 = [X2_train1; X2_train2; X2_train3; X2_train4];
pasta_x3 = [X3_train1; X3_train2; X3_train3; X3_train4];
pasta_x4 = [X4_train1; X4_train2; X4_train3; X4_train4];

pasta_y1 = [clas1; clas2; clas3; clas4];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Identificando as quantidades em cada classe %%%%%
setosa_1=0;versicolor_1=0;verginica_1=0;
for i=1:120
    switch pasta_y1(i)
        case 1
            setosa_1 = setosa_1+1;
        case 2
            versicolor_1 = versicolor_1+1;
        case 3
            verginica_1 = verginica_1+1;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Calculando a probabilidade a priori %%%%%%%%%%%%
P1_w1 = setosa_1/120;P1_w2 = versicolor_1/120;P1_w3 = verginica_1/120;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%                   PDF                 %%%%%%%%%%

%media
med1_1 = mean(pasta_x1(1:50));med1_2 = mean(pasta_x1(51:100));med1_3 = mean(pasta_x1(101:120));
med2_1 = mean(pasta_x2(1:50));med2_2 = mean(pasta_x2(51:100));med2_3 = mean(pasta_x2(101:120));
med3_1 = mean(pasta_x3(1:50));med3_2 = mean(pasta_x3(51:100));med3_3 = mean(pasta_x3(101:120));
med4_1 = mean(pasta_x4(1:50));med4_2 = mean(pasta_x4(51:100));med4_3 = mean(pasta_x4(101:120));
%desvio padrao
dp1_1 = std(pasta_x1(1:50));dp1_2 = std(pasta_x1(51:100));dp1_3 = std(pasta_x1(101:120));
dp2_1 = std(pasta_x2(1:50));dp2_2 = std(pasta_x2(51:100));dp2_3 = std(pasta_x2(101:120));
dp3_1 = std(pasta_x3(1:50));dp3_2 = std(pasta_x3(51:100));dp3_3 = std(pasta_x3(101:120));
dp4_1 = std(pasta_x4(1:50));dp4_2 = std(pasta_x4(51:100));dp4_3 = std(pasta_x4(101:120));

%PDF
PDF1_1 = normpdf(X1_train5,med1_1,dp1_1);PDF1_2 = normpdf(X1_train5,med1_2,dp1_2);PDF1_3 = normpdf(X1_train5,med1_3,dp1_3);
PDF2_1 = normpdf(X2_train5,med2_1,dp2_1);PDF2_2 = normpdf(X2_train5,med2_2,dp2_2);PDF2_3 = normpdf(X2_train5,med2_3,dp2_3);
PDF3_1 = normpdf(X3_train5,med3_1,dp3_1);PDF3_2 = normpdf(X3_train5,med3_2,dp3_2);PDF3_3 = normpdf(X3_train5,med3_3,dp3_3);
PDF4_1 = normpdf(X4_train5,med4_1,dp4_1);PDF4_2 = normpdf(X4_train5,med4_2,dp4_2);PDF4_3 = normpdf(X4_train5,med4_3,dp4_3);

proba1_1 = P1_w1*PDF1_1.*PDF2_1.*PDF3_1.*PDF4_1;  
proba2_1 = P1_w2*PDF1_2.*PDF2_2.*PDF3_2.*PDF4_2;
proba3_1 = P1_w3*PDF1_3.*PDF2_3.*PDF3_3.*PDF4_3; 

pasta_prob = [proba1_1 proba2_1 proba3_1];

err_1 = 0;
for i=1:30
    [X,C] = max(pasta_prob(i,:));
    classee(i) = C;
end
for i=1:30
    if abs(clas5(i)-classee(i))>0
    err_1 = err_1+1;
    end
end
err_1 = err_1/30;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%              Pasta 2                     %%%%%%%%
pasta2_x1 = [X1_train1; X1_train2; X1_train3; X1_train5];
pasta2_x2 = [X2_train1; X2_train2; X2_train3; X2_train5];
pasta2_x3 = [X3_train1; X3_train2; X3_train3; X3_train5];
pasta2_x4 = [X4_train1; X4_train2; X4_train3; X4_train5];

pasta_y2 = [clas1; clas2; clas3; clas5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Identificando as quantidades em cada classe %%%%%
setosa_2=0;versicolor_2=0;verginica_2=0;
for i=1:120
    switch pasta_y2(i)
        case 1
            setosa_2 = setosa_2+1;
        case 2
            versicolor_2 = versicolor_2+1;
        case 3
            verginica_2 = verginica_2+1;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Calculando a probabilidade a priori %%%%%%%%%%%%
P2_w1 = setosa_2/120;P2_w2 = versicolor_2/120;P2_w3 = verginica_2/120;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%                   PDF                 %%%%%%%%%%

%media
med1_p2_1 = mean(pasta2_x1(1:50));med1_p2_2 = mean(pasta2_x1(51:90));med1_p2_3 = mean(pasta2_x1(91:120));
med2_p2_1 = mean(pasta2_x2(1:50));med2_p2_2 = mean(pasta2_x2(51:90));med2_p2_3 = mean(pasta2_x2(91:120));
med3_p2_1 = mean(pasta2_x3(1:50));med3_p2_2 = mean(pasta2_x3(51:90));med3_p2_3 = mean(pasta2_x3(91:120));
med4_p2_1 = mean(pasta2_x4(1:50));med4_p2_2 = mean(pasta2_x4(51:90));med4_p2_3 = mean(pasta2_x4(91:120));
%desvio padrao
dp1_p2_1 = std(pasta2_x1(1:50));dp1_p2_2 = std(pasta2_x1(51:90));dp1_p2_3 = std(pasta2_x1(91:120));
dp2_p2_1 = std(pasta2_x2(1:50));dp2_p2_2 = std(pasta2_x2(51:90));dp2_p2_3 = std(pasta2_x2(91:120));
dp3_p2_1 = std(pasta2_x3(1:50));dp3_p2_2 = std(pasta2_x3(51:90));dp3_p2_3 = std(pasta2_x3(91:120));
dp4_p2_1 = std(pasta2_x4(1:50));dp4_p2_2 = std(pasta2_x4(51:90));dp4_p2_3 = std(pasta2_x4(91:120));

%PDF
PDF1_p2_1 = normpdf(X1_train4,med1_p2_1,dp1_p2_1);PDF1_p2_2 = normpdf(X1_train4,med1_p2_2,dp1_p2_2);PDF1_p2_3 = normpdf(X1_train4,med1_p2_3,dp1_p2_3);
PDF2_p2_1 = normpdf(X2_train4,med2_p2_1,dp2_p2_1);PDF2_p2_2 = normpdf(X2_train4,med2_p2_2,dp2_p2_2);PDF2_p2_3 = normpdf(X2_train4,med2_p2_3,dp2_p2_3);
PDF3_p2_1 = normpdf(X3_train4,med3_p2_1,dp3_p2_1);PDF3_p2_2 = normpdf(X3_train4,med3_p2_2,dp3_p2_2);PDF3_p2_3 = normpdf(X3_train4,med3_p2_3,dp3_p2_3);
PDF4_p2_1 = normpdf(X4_train4,med4_p2_1,dp4_p2_1);PDF4_p2_2 = normpdf(X4_train4,med4_p2_2,dp4_p2_2);PDF4_p2_3 = normpdf(X4_train4,med4_p2_3,dp4_p2_3);

proba1_p2_1 = PDF1_p2_1.*PDF2_p2_1.*PDF3_p2_1.*PDF4_p2_1*P2_w1; 
proba2_p2_1 = PDF1_p2_2.*PDF2_p2_2.*PDF3_p2_2.*PDF4_p2_2*P2_w2;
proba3_p2_1 = PDF1_p2_3.*PDF2_p2_3.*PDF3_p2_3.*PDF4_p2_3*P2_w3; 


pasta_prob2 = [proba1_p2_1 proba2_p2_1 proba3_p2_1];

err_2 = 0;
for i=1:30
    [X,C] = max(pasta_prob2(i,:));
    classee2(i) = C;
end
for i=1:30
    if abs(clas4(i)-classee2(i))>0
    err_2 = err_2+1;
    end
end
err_2 = err_2/30;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%              Pasta 3                     %%%%%%%%
pasta3_x1 = [X1_train1; X1_train2; X1_train4; X1_train5];
pasta3_x2 = [X2_train1; X2_train2; X2_train4; X2_train5];
pasta3_x3 = [X3_train1; X3_train2; X3_train4; X3_train5];
pasta3_x4 = [X4_train1; X4_train2; X4_train4; X4_train5];

pasta_y3 = [clas1; clas2; clas4; clas5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Identificando as quantidades em cada classe %%%%%
setosa_3=0;versicolor_3=0;verginica_3=0;
for i=1:120
    switch pasta_y3(i)
        case 1
            setosa_3 = setosa_3+1;
        case 2
            versicolor_3 = versicolor_3+1;
        case 3
            verginica_3 = verginica_3+1;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Calculando a probabilidade a priori %%%%%%%%%%%%
P3_w1 = setosa_3/120;P3_w2 = versicolor_3/120;P3_w3 = verginica_3/120;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%                   PDF                 %%%%%%%%%%

%media
med1_p3_1 = mean(pasta3_x1(1:50));med1_p3_2 = mean(pasta3_x1(51:70));med1_p3_3 = mean(pasta3_x1(71:120));
med2_p3_1 = mean(pasta3_x2(1:50));med2_p3_2 = mean(pasta3_x2(51:70));med2_p3_3 = mean(pasta3_x2(71:120));
med3_p3_1 = mean(pasta3_x3(1:50));med3_p3_2 = mean(pasta3_x3(51:70));med3_p3_3 = mean(pasta3_x3(71:120));
med4_p3_1 = mean(pasta3_x4(1:50));med4_p3_2 = mean(pasta3_x4(51:70));med4_p3_3 = mean(pasta3_x4(71:120));
%desvio padrao
dp1_p3_1 = std(pasta3_x1(1:50));dp1_p3_2 = std(pasta3_x1(51:70));dp1_p3_3 = std(pasta3_x1(71:120));
dp2_p3_1 = std(pasta3_x2(1:50));dp2_p3_2 = std(pasta3_x2(51:70));dp2_p3_3 = std(pasta3_x2(71:120));
dp3_p3_1 = std(pasta3_x3(1:50));dp3_p3_2 = std(pasta3_x3(51:70));dp3_p3_3 = std(pasta3_x3(71:120));
dp4_p3_1 = std(pasta3_x4(1:50));dp4_p3_2 = std(pasta3_x4(51:70));dp4_p3_3 = std(pasta3_x4(71:120));

%PDF
PDF1_p3_1 = normpdf(X1_train3,med1_p3_1,dp1_p3_1);PDF1_p3_2 = normpdf(X1_train3,med1_p3_2,dp1_p3_2);PDF1_p3_3 = normpdf(X1_train3,med1_p3_3,dp1_p3_3);
PDF2_p3_1 = normpdf(X2_train3,med2_p3_1,dp2_p3_1);PDF2_p3_2 = normpdf(X2_train3,med2_p3_2,dp2_p3_2);PDF2_p3_3 = normpdf(X2_train3,med2_p3_3,dp2_p3_3);
PDF3_p3_1 = normpdf(X3_train3,med3_p3_1,dp3_p3_1);PDF3_p3_2 = normpdf(X3_train3,med3_p3_2,dp3_p3_2);PDF3_p3_3 = normpdf(X3_train3,med3_p3_3,dp3_p3_3);
PDF4_p3_1 = normpdf(X4_train3,med4_p3_1,dp4_p3_1);PDF4_p3_2 = normpdf(X4_train3,med4_p3_2,dp4_p3_2);PDF4_p3_3 = normpdf(X4_train3,med4_p3_3,dp4_p3_3);

proba1_p3_1 = PDF1_p3_1.*PDF2_p3_1.*PDF3_p3_1.*PDF4_p3_1*P3_w1;  
proba2_p3_1 = PDF1_p3_2.*PDF2_p3_2.*PDF3_p3_2.*PDF4_p3_2*P3_w2;
proba3_p3_1 = PDF1_p3_3.*PDF2_p3_3.*PDF3_p3_3.*PDF4_p3_3*P3_w3; 


pasta_prob3 = [proba1_p3_1 proba2_p3_1 proba3_p3_1];

err_3 = 0;
for i=1:30
    [X,C] = max(pasta_prob3(i,:));
    classee3(i) = C;
end
for i=1:30
    if abs(clas3(i)-classee3(i))>0
    err_3 = err_3+1;
    end
end
err_3 = err_3/30;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%              Pasta 4                     %%%%%%%%
pasta4_x1 = [X1_train1; X1_train3; X1_train4; X1_train5];
pasta4_x2 = [X2_train1; X2_train3; X2_train4; X2_train5];
pasta4_x3 = [X3_train1; X3_train3; X3_train4; X3_train5];
pasta4_x4 = [X4_train1; X4_train3; X4_train4; X4_train5];

pasta_y4 = [clas1; clas3; clas4; clas5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Identificando as quantidades em cada classe %%%%%
setosa_4=0;versicolor_4=0;verginica_4=0;
for i=1:120
    switch pasta_y4(i)
        case 1
            setosa_4 = setosa_4+1;
        case 2
            versicolor_4 = versicolor_4+1;
        case 3
            verginica_4 = verginica_4+1;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Calculando a probabilidade a priori %%%%%%%%%%%%
P4_w1 = setosa_4/120;P4_w2 = versicolor_4/120;P4_w3 = verginica_4/120;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%                   PDF                 %%%%%%%%%%

%media
med1_p4_1 = mean(pasta4_x1(1:50));med1_p4_2 = mean(pasta4_x1(51:70));med1_p4_3 = mean(pasta4_x1(71:120));
med2_p4_1 = mean(pasta4_x2(1:50));med2_p4_2 = mean(pasta4_x2(51:70));med2_p4_3 = mean(pasta4_x2(71:120));
med3_p4_1 = mean(pasta4_x3(1:50));med3_p4_2 = mean(pasta4_x3(51:70));med3_p4_3 = mean(pasta4_x3(71:120));
med4_p4_1 = mean(pasta4_x4(1:50));med4_p4_2 = mean(pasta4_x4(51:70));med4_p4_3 = mean(pasta4_x4(71:120));
%desvio padrao
dp1_p4_1 = std(pasta4_x1(1:50));dp1_p4_2 = std(pasta4_x1(51:70));dp1_p4_3 = std(pasta4_x1(71:120));
dp2_p4_1 = std(pasta4_x2(1:50));dp2_p4_2 = std(pasta4_x2(51:70));dp2_p4_3 = std(pasta4_x2(71:120));
dp3_p4_1 = std(pasta4_x3(1:50));dp3_p4_2 = std(pasta4_x3(51:70));dp3_p4_3 = std(pasta4_x3(71:120));
dp4_p4_1 = std(pasta4_x4(1:50));dp4_p4_2 = std(pasta4_x4(51:70));dp4_p4_3 = std(pasta4_x4(71:120));

%PDF
PDF1_p4_1 = normpdf(X1_train2,med1_p4_1,dp1_p4_1);PDF1_p4_2 = normpdf(X1_train2,med1_p4_2,dp1_p4_2);PDF1_p4_3 = normpdf(X1_train2,med1_p4_3,dp1_p4_3);
PDF2_p4_1 = normpdf(X2_train2,med2_p4_1,dp2_p4_1);PDF2_p4_2 = normpdf(X2_train2,med2_p4_2,dp2_p4_2);PDF2_p4_3 = normpdf(X2_train2,med2_p4_3,dp2_p4_3);
PDF3_p4_1 = normpdf(X3_train2,med3_p4_1,dp3_p4_1);PDF3_p4_2 = normpdf(X3_train2,med3_p4_2,dp3_p4_2);PDF3_p4_3 = normpdf(X3_train2,med3_p4_3,dp3_p4_3);
PDF4_p4_1 = normpdf(X4_train2,med4_p4_1,dp4_p4_1);PDF4_p4_2 = normpdf(X4_train2,med4_p4_2,dp4_p4_2);PDF4_p4_3 = normpdf(X4_train2,med4_p4_3,dp4_p4_3);

proba1_p4_1 = PDF1_p4_1.*PDF2_p4_1.*PDF3_p4_1.*PDF4_p4_1*P4_w1;  
proba2_p4_1 = PDF1_p4_2.*PDF2_p4_2.*PDF3_p4_2.*PDF4_p4_2*P4_w2;
proba3_p4_1 = PDF1_p4_3.*PDF2_p4_3.*PDF3_p4_3.*PDF4_p4_3*P4_w3; 

pasta_prob4 = [proba1_p4_1 proba2_p4_1 proba3_p4_1];

err_4 = 0;
for i=1:30
    [X,C] = max(pasta_prob4(i,:));
    classee4(i) = C;
end
for i=1:30
    if abs(clas2(i)-classee4(i))>0
    err_4 = err_4+1;
    end
end
err_4 = err_4/30;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%              Pasta 5                     %%%%%%%%
pasta5_x1 = [X1_train2; X1_train3; X1_train4; X1_train5];
pasta5_x2 = [X2_train2; X2_train3; X2_train4; X2_train5];
pasta5_x3 = [X3_train2; X3_train3; X3_train4; X3_train5];
pasta5_x4 = [X4_train2; X4_train3; X4_train4; X4_train5];

pasta_y5 = [clas2; clas3; clas4; clas5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Identificando as quantidades em cada classe %%%%%
setosa_5=0;versicolor_5=0;verginica_5=0;
for i=1:120
    switch pasta_y5(i)
        case 1
            setosa_5 = setosa_5+1;
        case 2
            versicolor_5 = versicolor_5+1;
        case 3
            verginica_5 = verginica_5+1;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Calculando a probabilidade a priori %%%%%%%%%%%%
P5_w1 = setosa_5/120;P5_w2 = versicolor_5/120;P5_w3 = verginica_5/120;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%                   PDF                 %%%%%%%%%%

%media
med1_p5_1 = mean(pasta5_x1(1:50));med1_p5_2 = mean(pasta5_x1(51:70));med1_p5_3 = mean(pasta5_x1(71:120));
med2_p5_1 = mean(pasta5_x2(1:50));med2_p5_2 = mean(pasta5_x2(51:70));med2_p5_3 = mean(pasta5_x2(71:120));
med3_p5_1 = mean(pasta5_x3(1:50));med3_p5_2 = mean(pasta5_x3(51:70));med3_p5_3 = mean(pasta5_x3(71:120));
med4_p5_1 = mean(pasta5_x4(1:50));med4_p5_2 = mean(pasta5_x4(51:70));med4_p5_3 = mean(pasta5_x4(71:120));
%desvio padrao
dp1_p5_1 = std(pasta5_x1(1:50));dp1_p5_2 = std(pasta5_x1(51:70));dp1_p5_3 = std(pasta5_x1(71:120));
dp2_p5_1 = std(pasta5_x2(1:50));dp2_p5_2 = std(pasta5_x2(51:70));dp2_p5_3 = std(pasta5_x2(71:120));
dp3_p5_1 = std(pasta5_x3(1:50));dp3_p5_2 = std(pasta5_x3(51:70));dp3_p5_3 = std(pasta5_x3(71:120));
dp4_p5_1 = std(pasta5_x4(1:50));dp4_p5_2 = std(pasta5_x4(51:70));dp4_p5_3 = std(pasta5_x4(71:120));

%PDF
PDF1_p5_1 = normpdf(X1_train1,med1_p5_1,dp1_p5_1);PDF1_p5_2 = normpdf(X1_train1,med1_p5_2,dp1_p5_2);PDF1_p5_3 = normpdf(X1_train1,med1_p5_3,dp1_p5_3);
PDF2_p5_1 = normpdf(X2_train1,med2_p5_1,dp2_p5_1);PDF2_p5_2 = normpdf(X2_train1,med2_p5_2,dp2_p5_2);PDF2_p5_3 = normpdf(X2_train1,med2_p5_3,dp2_p5_3);
PDF3_p5_1 = normpdf(X3_train1,med3_p5_1,dp3_p5_1);PDF3_p5_2 = normpdf(X3_train1,med3_p5_2,dp3_p5_2);PDF3_p5_3 = normpdf(X3_train1,med3_p5_3,dp3_p5_3);
PDF4_p5_1 = normpdf(X4_train1,med4_p5_1,dp4_p5_1);PDF4_p5_2 = normpdf(X4_train1,med4_p5_2,dp4_p5_2);PDF4_p5_3 = normpdf(X4_train1,med4_p5_3,dp4_p5_3);

proba1_p5_1 = PDF1_p5_1.*PDF2_p5_1.*PDF3_p5_1.*PDF4_p5_1*P5_w1;  
proba2_p5_1 = PDF1_p5_2.*PDF2_p5_2.*PDF3_p5_2.*PDF4_p5_2*P5_w2;
proba3_p5_1 = PDF1_p5_3.*PDF2_p5_3.*PDF3_p5_3.*PDF4_p5_3*P5_w3; 

pasta_prob5 = [proba1_p5_1 proba2_p5_1 proba3_p5_1];

err_5 = 0;
for i=1:30
    [X,C] = max(pasta_prob5(i,:));
    classee5(i) = C;
end
for i=1:30
    if abs(clas1(i)-classee5(i))>0
    err_5 = err_5+1;
    end
end
err_5 = err_5/30;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%     Taxa de erro e acerto          %%%%%%%%%%%%%%%%

acert1 = 1-err_1;acert2 = 1-err_2;acert3 = 1-err_3;acert4 = 1-err_4;acert5 = 1-err_5;

em = (err_1+err_2+err_3+err_4+err_5)/5;

acertm = (acert1+acert2+acert3+acert4+acert5)/5
