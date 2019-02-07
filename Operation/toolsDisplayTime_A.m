function output = toolsDisplayTime_A(input, prm)
%prm(1)-->lambda
%prm(2)-->sigma
%prm(3)--># of iterations

try
    if input
        input=input+1;
    end
catch
    input=2;
end


if mod(prm.Nb_iterations,input-1)==0 %|| input==0
    
    %disp(sprintf('\n\nTemps total : %.1f mn ou %.1f hr ou %.1f j', prm.TotalTime/60, prm.TotalTime/3600, prm.TotalTime/86400));
    
    disp(sprintf('%s', prm.Source));
    
    moy=prm.TotalTime/prm.Nb_IterTotal;
    disp(sprintf('Temps moyen : %.4f s', moy));
    
    est=moy*prm.Nb_IterTotal;
    disp(sprintf('Estimation temps :  %.0f s %.1f mn ou %.1f h', est, est/60,est/3600));
    
    rest=est-(prm.Nb_iterations*moy);
    disp(sprintf('Temps restant : %.0f s %.1f mn ou %.1f h', rest, rest/60,rest/3600));
    
    disp(sprintf('Temps 1400 images : %.1f hr ou %.1f j', (moy*1400)/3600,(moy*1400)/86400));
    disp(sprintf('Temps 10000 images : %.1f hr ou %.1f j', (moy*10000)/3600,(moy*10000)/86400));
    disp(sprintf('Temps 30000 images : %.1f hr ou %.1f j', (moy*30000)/3600,(moy*30000)/86400));
    
    disp(sprintf('Pourcentage restant : %.1f %%\n\n', 100-((rest/est)*100)));
    
end

output=true;
end

