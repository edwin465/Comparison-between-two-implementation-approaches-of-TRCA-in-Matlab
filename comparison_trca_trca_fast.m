% trca_fast vs trca
clear all
close all
n_point=250;
n_trial=1000;
X=zeros(9,n_point,n_trial);
tic
for k=1:n_trial
    X0=randn(9,n_point);
    X0=X0-mean(X0,2)*ones(1,length(X0));
    X0=X0./(std(X0')'*ones(1,length(X0)));
    X(:,:,k)=X0;
end
toc

trial_num=[1:10 50 100:100:1000];
trca_t=zeros(10,length(trial_num));
trca_w=zeros(9,9,length(trial_num));
for cv=1:10    
    for m=1:length(trial_num)
        tic;
        [w_tmp,~]=trca(X(:,:,1:trial_num(m)));        
        trca_t(cv,m)=toc;
        trca_w(:,:,m)=w_tmp;
    end
end

trca_fast_t=zeros(10,length(trial_num));
trca_fast_w=zeros(9,9,length(trial_num));
for cv=1:10
    for m=1:length(trial_num)
        tic;
        [w_tmp,~]=trca_fast(X(:,:,1:trial_num(m))); 
        trca_fast_t(cv,m)=toc;
        trca_fast_w(:,:,m)=w_tmp;
    end
end

for m=1:length(trial_num)    
    w_err(m)=norm(abs(trca_w(:,:,m))-abs(trca_fast_w(:,:,m)));
end
mu_trca_fast_t=mean(trca_fast_t,1);
mu_trca_t=mean(trca_t,1);
sd_trca_fast_t=std(trca_fast_t);
sd_trca_t=std(trca_t);
figure(1);
subplot(1,2,1);
e1=errorbar([2:10],mu_trca_fast_t(2:10),sd_trca_fast_t(2:10));hold on;
e2=errorbar([2:10],mu_trca_t(2:10),sd_trca_t(2:10));hold off;
e1.Color = 'red';
e2.Color = 'blue';
e1.LineWidth = 2;
e2.LineWidth = 2;
xlim([1 11]);
legend('New','Old');
xlabel('Num. of trials');
ylabel('Calculation time');
set(gca,'fontsize',20,'linewidth',2);

subplot(1,2,2);
e1=errorbar([11:length(trial_num)],mu_trca_fast_t(11:length(trial_num)),sd_trca_fast_t(11:length(trial_num)));hold on;
e2=errorbar([11:length(trial_num)],mu_trca_t(11:length(trial_num)),sd_trca_t(11:length(trial_num)));hold off;
e1.Color = 'red';
e2.Color = 'blue';
e1.LineWidth = 2;
e2.LineWidth = 2;
ax=gca;
ax.XTick=[11:length(trial_num)];
ax.XTickLabel={'50','100','200','300','400','500','600','700','800','900','1000'};
xtickangle(90);
legend('New','Old');
xlabel('Num. of trials');
ylabel('Calculation time');
set(gca,'fontsize',20,'linewidth',2);

figure(2);
plot([1:length(trial_num)],w_err,'linewidth',2);
ax=gca;
ax.XTick=[1:length(trial_num)];
ax.XTickLabel={'1','2','3','4','5','6','7','8','9','10','50','100','200','300','400','500','600','700','800','900','1000'};
xtickangle(90);
xlabel('Num. of trials');
ylabel('Mean square error');
set(gca,'fontsize',20,'linewidth',2);



