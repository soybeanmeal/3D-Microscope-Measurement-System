function val = get(c,propName)
% function val = get(c,propName)
switch propName
    case'pos'
        val = qPOS(c,'');
    case'idn'
        val = qIDN(c);
    otherwise
        error([propName,' is not a valid property']);
end