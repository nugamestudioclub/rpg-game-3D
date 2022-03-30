using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IntroLevelManager : MonoBehaviour
{
    [SerializeField]
    private FloorCollapseComponent collapseComponent;

    private bool startEarthQuake = false;
    /// <summary>
    /// Duration in seconds the cave shakes until the floor collapses under the player.
    /// </summary>
    [SerializeField]
    private float earthQuakeLength;

    private float quakeStartTime = 0;

    // Start is called before the first frame update
    void Start()
    {
       
    }

    private void StartQuake()
    {
        this.startEarthQuake = true;
        this.quakeStartTime = Time.time;
    }


    // Update is called once per frame
    void Update()
    {
        if (this.startEarthQuake)
        {
            float deltaTime = Time.time - this.quakeStartTime;
            if (deltaTime >= earthQuakeLength)
            {
                collapseComponent.Release();
                this.startEarthQuake = false;
            }

        }

    }
}
