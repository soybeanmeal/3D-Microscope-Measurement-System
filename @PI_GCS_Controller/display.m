function display(c)
disp('PI_GCS_Controller class object');
disp(sprintf('ID: %d',c.ID));
disp(sprintf('IDN: %s',c.IDN));
if(c.NumberOfAxes>1)
    disp(sprintf('%d possible axes',c.NumberOfAxes));
else
    disp(sprintf('%d possible axis',c.NumberOfAxes));
end
    