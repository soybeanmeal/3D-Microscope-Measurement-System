function c = InitializeController(c)
%function c = InitializeController(c)
szAxes = qSAI_ALL(c);
c.NumberOfAxes = length(szAxes)-1;
c.IDN = qIDN(c);