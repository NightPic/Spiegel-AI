function findSelectedProfile(profiles) {
    let selectedProfile = profiles.find(profile => profile.isSelected);
    if (selectedProfile)
        return selectedProfile;

    return null;
}