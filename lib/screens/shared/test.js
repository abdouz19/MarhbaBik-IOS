async function handleProceed() {
    const uid = firebase.auth().currentUser.uid;
    setIsLoading(true);
    try {
      const result = await apiService.createTransfer(totalPrice, uid, 'https://www.google.com/');
      console.log(result);
      if (result.success) {
        const url = result.url;
        const transferId = result.id.toString();
  
        // Open URL in scaffold
        const launched = await UrlHandler.open(url);
        if (!launched) {
          throw 'Could not launch ' + url;
        }
  
        // Check transfer details
        const transferDetails = await apiService.getTransferDetails(transferId);
        console.log('Transfer details: ', transferDetails);
        if (transferDetails.completed) {
          // Parse created_at and calculate expiration date
          const createdAt = new Date(transferDetails.data.created_at);
          const expirationDate = new Date(createdAt.getTime() + (30 * 24 * 60 * 60 * 1000));
  
          // Save subscription to Firestore
          const subscriptionData = {
            userId: uid,
            transferId: transferDetails.data.id,
            serial: transferDetails.data.serial,
            amount: transferDetails.data.amount,
            rib: transferDetails.data.rib,
            firstname: transferDetails.data.firstname,
            lastname: transferDetails.data.lastname,
            address: transferDetails.data.address,
            status: transferDetails.data.status,
            created_at: transferDetails.data.created_at,
            expiration_date: expirationDate.toISOString().slice(0, 10),
          };
  
          await FirestoreService.saveSubscription(uid, subscriptionData);
  
          // Handle completed transfer
          console.log('Transfer completed successfully and subscription saved.');
        } else {
          // Handle incomplete transfer
          console.log('Transfer not completed.');
        }
      } else {
        throw new Error(result.message);
      }
    } catch (e) {
      console.error('Error: ', e);
    } finally {
      setIsLoading(false);
    }
  }
  