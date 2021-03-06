function Sout = internalSOCestimate(cs_average_t,param,i)
%   internalSOCestimate is used to get a measurement of the SOC according to the
%   internal states. This function assumes that all the states are
%   measurable.

%   This file is part of the LIONSIMBA Toolbox
%
%	Official web-site: 	http://sisdin.unipv.it/labsisdin/lionsimba.php
% 	Official GitHUB: 	https://github.com/lionsimbatoolbox/LIONSIMBA
%
%   LIONSIMBA: A Matlab framework based on a finite volume model suitable for Li-ion battery design, simulation, and control
%   Copyright (C) 2016-2018 :Marcello Torchio, Lalo Magni, Davide Raimondo,
%                            University of Pavia, 27100, Pavia, Italy
%                            Bhushan Gopaluni, Univ. of British Columbia, 
%                            Vancouver, BC V6T 1Z3, Canada
%                            Richard D. Braatz, 
%                            Massachusetts Institute of Technology, 
%                            Cambridge, Massachusetts 02142, USA
%   
%   Main code contributors to LIONSIMBA 2.0:
%                           Ian Campbell, Krishnakumar Gopalakrishnan,
%                           Imperial college London, London, UK
%
%   LIONSIMBA is a free Matlab-based software distributed with an MIT
%   license.

% Check if Fick's law of diffusion is used. This is required to define the
% correct way how to evaluate the SOC.
if(param{i}.SolidPhaseDiffusion~=3)
    cs_average = cs_average_t{i}(end,param{i}.Np+1:end);
else
    start_index = param{i}.Nr_p*param{i}.Np+1;
    end_index   = start_index+param{i}.Nr_n-1;
    cs_average  = zeros(param{i}.Nn,1);
    for n=1:param{i}.Nn
        cs_average(n)   = 1/param{i}.Rp_n*(param{i}.Rp_n/param{i}.Nr_n)*sum(cs_average_t{i}(end,start_index:end_index));
        start_index     = end_index + 1;
        end_index       = end_index + param{i}.Nr_n;
    end
end
Csout  = sum(cs_average);
Sout   = 100*((1/param{i}.len_n*(param{i}.len_n/(param{i}.Nn))*Csout/param{i}.cs_maxn)-param{i}.theta_min_neg)/(param{i}.theta_max_neg-param{i}.theta_min_neg);
end