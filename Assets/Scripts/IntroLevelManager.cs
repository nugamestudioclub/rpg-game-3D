using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IntroLevelManager : MonoBehaviour
{
    [SerializeField]
    private FloorCollapseComponent[] collapseComponent;
    [SerializeField]
    private CameraShaker cameraShaker;

    private bool startEarthQuake = false;
    /// <summary>
    /// Duration in seconds the cave shakes until the floor collapses under the player.
    /// </summary>
    [SerializeField]
    private float earthQuakeLength;

    private float quakeStartTime = 0;
    [SerializeField]
    private bool startEvent = false;

    private bool eventStarted = false;
    

    // Start is called before the first frame update
    void Start()
    {
       
    }

    private void StartQuake()
    {
        this.startEarthQuake = true;
        this.quakeStartTime = Time.time;
        this.cameraShaker.duration = earthQuakeLength;
        this.cameraShaker.StartShake();

    }


    // Update is called once per frame
    void Update()
    {

        if (this.startEvent != this.eventStarted||Input.GetKeyDown(KeyCode.U))
        {
            this.StartQuake();
            this.startEvent = true;
            this.eventStarted = true;
        }

        if (this.startEarthQuake)
        {
            float deltaTime = Time.time - this.quakeStartTime;
            if (deltaTime >= earthQuakeLength)
            {
                foreach(FloorCollapseComponent component in collapseComponent)
                {
                    component.Release();
                }
                
                this.startEarthQuake = false;
            }

        }

    }
}
