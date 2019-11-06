function model_data_thr =  SF_params_thr(model_data,thr_index,opt)
% NP_params_thr - function to obtain the thresholed pRF parameters 
% Run after - model_data = GetInfoModel(model_file,coords_file,roi_file) 
%

model_data_thr.HRF = model_data.HRF;
model_data_thr.sigma = model_data.sigma(thr_index);
model_data_thr.sigma_norm = model_data_thr.sigma ./ (mean(model_data_thr.sigma,2));
model_data_thr.ecc = model_data.ecc(thr_index);
model_data_thr.latx = model_data.latx(thr_index);
model_data_thr.laty = model_data.laty(thr_index);
model_data_thr.beta = model_data.beta(thr_index);
model_data_thr.betaDC = model_data.betaDC(thr_index);
model_data_thr.varexp = model_data.varexp(thr_index);
model_data_thr.rss = model_data.rss(thr_index);
model_data_thr.pol = model_data.pol(thr_index);
model_data_thr.x = model_data.x(thr_index);
model_data_thr.y = model_data.y(thr_index);
model_data_thr.dc = model_data.dc(thr_index);
model_data_thr.posvol = model_data.posvol(thr_index);

% difference of Gaussians parameters
if strcmpi(opt.modelType,'DoGs')
    model_data_thr.sigma2 = model_data.sigma2(thr_index);
    model_data_thr.DoGs_fwhmax = model_data.DoGs_fwhmax(thr_index);
    model_data_thr.DoGs_surroundSize = model_data.DoGs_surroundSize(thr_index);
    model_data_thr.DoGs_fwhmin_first = model_data.DoGs_fwhmin_first(thr_index);
    model_data_thr.DoGs_fwhmin_second = model_data.DoGs_fwhmin_second(thr_index);
    model_data_thr.DoGs_diffwhmin = model_data.DoGs_diffwhmin(thr_index);
%    model_data_thr.DoGs_surr_depth = model_data.DoGs_surr_depth(thr_index);
end
end