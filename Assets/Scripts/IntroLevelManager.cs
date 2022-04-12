using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

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

    [SerializeField]
    private Animator playerAnim;

    [SerializeField]
    private float timeUntilSceneTransition = 10f;
    [SerializeField]
    private float fadeOutDuration = 1f;
    [SerializeField]
    private Animator UIAnimator;
    [SerializeField]
    private Canvas UICoverCanvas;
    [SerializeField]
    private string nextSceneName;
    [SerializeField]
    private LightInitiator pedestal;
    [SerializeField]
    private CharacterAnimationController player;
    [SerializeField]
    private float minDistanceToPedestal = 5f;

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
        //playerAnim.SetTrigger("UnexpectedFall");
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
                StartCoroutine(disableAllFloorsAfter(1));
                StartCoroutine(waitForSceneTransition(this.timeUntilSceneTransition,fadeOutDuration));
                this.startEarthQuake = false;
            }

        }
        if (Vector3.Distance(pedestal.transform.position,player.transform.position)<minDistanceToPedestal)
        {
            print("IN RANGE!!!");
            if (Input.GetButtonDown("Interact"))
            {
                pedestal.Rotate90();
            }
        }

    }

    private IEnumerator disableAllFloorsAfter(float time)
    {
        yield return new WaitForSeconds(time);
        foreach (FloorCollapseComponent component in collapseComponent)
        {
            component.Disable();
        }
    }

    private IEnumerator sceneTransition(float time)
    {
        yield return new WaitForSeconds(time);
        SceneManager.LoadScene(this.nextSceneName);
    }

    private IEnumerator waitForSceneTransition(float time,float fadeOutDuration)
    {
        
        
        yield return new WaitForSeconds(time);
        UICoverCanvas.gameObject.SetActive(true);
        StartCoroutine(sceneTransition(fadeOutDuration));
    }
}
