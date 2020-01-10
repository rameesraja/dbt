select 
id,concat(first_name,' ',last_name) as name,email
from {{ ref('selectCustomerSource') }}

