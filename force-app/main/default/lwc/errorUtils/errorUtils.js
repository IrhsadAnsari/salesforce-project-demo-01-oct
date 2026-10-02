export function reduceErrors(errors) {
    if (!Array.isArray(errors)) {

    errors = [errors];

    }

return (errors.filter(error => !!error).map(error => {
    // UI API & Apex Errors
    if (error.body) {
    // Validation Rule / DML Errors
    if (error.body.output?.errors?.length) {
    return error.body.output.errors
    .map(e => e.message);

    }
            // Field Level Errors
        if (error.body.output?.fieldErrors) {
        
        return Object.values(error.body.output.fieldErrors).flat().map(e => e.message);

        }

        if (typeof error.body.message === 'string') {
        return error.body.message;
        }
   }
    if (typeof error.message === 'string') {
    return error.message;
    }
    return 'Unknown Error';
    })
    .flat()
    .join(', '));
}